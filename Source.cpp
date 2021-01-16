#include<iostream>
#include<vector>
#include<queue>

using namespace std;
#define MAX 2147483647

class node
{
public:
	int distance;
	int distance_from_start;
	bool inserted;
	vector< pair<node*, int> >neighbors;
	node() { distance = MAX; inserted = false; distance_from_start = MAX; }
};

void traverse(node* arr, int& n, int& s, bool& flagtostop)
{
	queue<node*> q;
	q.push(&arr[s]);
	arr[s].inserted = true;
	flagtostop = true;

	node* temp;
	while (!q.empty())
	{
		temp = q.front();
		q.pop();

		for (int i = 0; i < temp->neighbors.size(); i++)
		{
			if (temp->distance + temp->neighbors[i].second < temp->neighbors[i].first->distance)
			{
				temp->neighbors[i].first->distance = temp->distance + temp->neighbors[i].second;
				temp->neighbors[i].first->distance_from_start = temp->distance_from_start + 1;
				flagtostop = false; // there is relaxation
			}
			if (!temp->neighbors[i].first->inserted)
			{
				q.push(temp->neighbors[i].first);
				temp->neighbors[i].first->inserted = true;
			}
		}
	}

	for (int i = 0; i < n; i++)
		arr[i].inserted = false;
}


int main()
{
	int n, m, s;
	cin >> n >> m >> s;

	node* arr = new node[n];
	for (int i = 0; i < m; i++)
	{
		bool flag = false;
		int p, c, w;
		cin >> p >> c >> w;

		for (int i = 0; i < arr[p].neighbors.size(); i++)
		{
			if (arr[p].neighbors[i].first == &arr[c])
			{
				if (w < arr[p].neighbors[i].second)
					arr[p].neighbors[i].second = w;
				flag = true;
				break;
			}
		}
		if (!flag)
			arr[p].neighbors.push_back(make_pair(&arr[c], w));
	}

	arr[s].distance = 0;
	arr[s].distance_from_start = 0;

	bool flagtostop = false;
	for (int i = 0; i < m; i++)
		if (!flagtostop)
			traverse(arr, n, s, flagtostop);
		else	// there is no more relaxation
			break;


	int furthest_city = s;
	int reachable_cities = n;
	for (int i = 0; i < n; i++)
	{
		if (arr[i].distance > arr[furthest_city].distance && arr[i].distance != MAX)
			furthest_city = i;

		if (arr[i].distance == MAX)
			reachable_cities--;
	}

	cout << reachable_cities << " " << arr[furthest_city].distance;
	delete[]arr;
}